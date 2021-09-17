package io.consortia.trial.webclient.service.impl;

import java.io.IOException;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeoutException;

import javax.validation.Valid;

import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.ContractException;
import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.gateway.Transaction;
import org.hyperledger.fabric.gateway.Wallet;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import io.consortia.trial.webclient.rest.InvokeInputDTO;
import io.consortia.trial.webclient.rest.InvokeResultDTO;
import io.consortia.trial.webclient.rest.QueryResultDTO;
import io.consortia.trial.webclient.service.ContractService;

@Service
public class ContractServiceImpl implements ContractService {

    String msp = System.getenv("CONS_FABRIC_MSP_ID");
    String fabricRootFolder = System.getenv("CONS_FABRIC_FOLDER");

    String adminUserName = System.getenv("adminUser");
    static {
        System.setProperty("org.hyperledger.fabric.sdk.proposal.wait.time", "300000");
    }
    Path networkConfigFile;
    Wallet wallet;

    public ContractServiceImpl() throws IOException {
        String walletFolder = System.getenv("WALLET_FOLDER");
        if (walletFolder == null) {
            walletFolder = "~/identity";
        }
        networkConfigFile = Paths.get(fabricRootFolder, "/network/" + msp + "/connection.json");
        Path walletDirectory = Paths.get(walletFolder, msp + "/wallet");
        wallet = Wallet.createFileSystemWallet(walletDirectory);
    }

    @Override
    public QueryResultDTO query(@Valid String channelId, @Valid String contractId, String... input) {
        try {
            Contract contract = connectToContract(channelId, contractId);
            byte[] queryAllCarsResult = contract.evaluateTransaction("query", input);
            String result = new String(queryAllCarsResult, StandardCharsets.UTF_8);

            QueryResultDTO dto = new QueryResultDTO();
            dto.setContractId(contractId);
            dto.setResult(result);
            return dto;
        } catch (ContractException e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public InvokeResultDTO invoke(@Valid String channelId, @Valid String contractId, String operation, InvokeInputDTO input) {
        try {
            Contract contract = connectToContract(channelId, contractId);
            Transaction transaction = contract.createTransaction(operation);

            // Submit transactions that store state to the ledger.
            byte[] resultBytes = transaction.setTransient(input.getTransientMap()).submit(input.getArgs());

            String result = new String(resultBytes, StandardCharsets.UTF_8);
            InvokeResultDTO dto = new InvokeResultDTO();
            dto.setContractId(contractId);
            dto.setResult(result);
            return dto;
        } catch (ContractException | TimeoutException | InterruptedException e) {
            throw new RuntimeException(e);
        }

    }

    public Contract connectToContract(String channelId, String contractId) {
        String userName = getCurrentUserName();
        try {
            Wallet.Identity identity = wallet.get(userName);
            if (identity == null) {
                identity = Wallet.Identity.createIdentity(msp, getCert(userName), getPKReader(userName));
                wallet.put(userName, identity);
            }

            Gateway.Builder builder = Gateway.createBuilder().identity(wallet, userName).networkConfig(networkConfigFile);
            Gateway gateway = builder.connect();

            // Obtain a smart contract deployed on the network.
            Network network = gateway.getNetwork(channelId);
            return network.getContract(contractId);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    String getCurrentUserName() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername();
        } else {
            return principal.toString();
        }
    }

    private Reader getCert(String userName) {
        if (userName.equals(adminUserName)) {
            Path crt = Paths.get(fabricRootFolder, "/pki/" + msp + "/admin/signcerts/cert.pem");
            try {
                return Files.newBufferedReader(crt);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        throw new RuntimeException("User Management not implemented");
    }

    private Reader getPKReader(String userName) {
        Path pk = null;
        if (userName.equals(adminUserName)) {
            pk = Paths.get(fabricRootFolder, "/pki/" + msp + "/admin/keystore/key.key");
            try {
                return Files.newBufferedReader(pk);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        throw new RuntimeException("User Management not implemented");
    }

}
