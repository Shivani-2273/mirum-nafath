package com.mirum.nafath.application.service.dto;

public class NafathStatusRequest {
    private String nationalId;
    private String transId;
    private String random;

    public NafathStatusRequest(String nationalId, String transId, String random) {
        this.nationalId = nationalId;
        this.transId = transId;
        this.random = random;
    }

    // Getters and setters
    public String getNationalId() { return nationalId; }
    public void setNationalId(String nationalId) { this.nationalId = nationalId; }
    public String getTransId() { return transId; }
    public void setTransId(String transId) { this.transId = transId; }
    public String getRandom() { return random; }
    public void setRandom(String random) { this.random = random; }
}