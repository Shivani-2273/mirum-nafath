package com.mirum.nafath.application.service.dto;

public class ApiResponse<T> {
    private boolean succeeded;
    private String message;
    private T data;
    private String[] errors;

    public ApiResponse(boolean succeeded, String message, T data, String[] errors) {
        this.succeeded = succeeded;
        this.message = message;
        this.data = data;
        this.errors = errors;
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "success", data, new String[0]);
    }

    public static <T> ApiResponse<T> error(String errorMessage) {
        return new ApiResponse<>(false, "error", null, new String[]{errorMessage});
    }

    // Getters and setters
    public boolean isSucceeded() { return succeeded; }
    public void setSucceeded(boolean succeeded) { this.succeeded = succeeded; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public T getData() { return data; }
    public void setData(T data) { this.data = data; }
    public String[] getErrors() { return errors; }
    public void setErrors(String[] errors) { this.errors = errors; }
}