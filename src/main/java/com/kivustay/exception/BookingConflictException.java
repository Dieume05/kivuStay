package com.kivustay.exception;

public class BookingConflictException extends Exception {

    private static final long serialVersionUID = 1L;

    public BookingConflictException(String message) {
        super(message);
    }
}