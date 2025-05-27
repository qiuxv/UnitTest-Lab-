package com.mengchaofan;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {

    private Calculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }

    @Test
    @DisplayName("加法测试")
    void testAdd() {
        assertEquals(5, calculator.add(2, 3), "2 + 3 应等于 5");
        assertEquals(-1, calculator.add(2, -3), "2 + (-3) 应等于 -1");
    }

    @Test
    @DisplayName("减法测试")
    void testSubtract() {
        assertEquals(-1, calculator.subtract(2, 3), "2 - 3 应等于 -1");
        assertEquals(5, calculator.subtract(2, -3), "2 - (-3) 应等于 5");
    }

    @Test
    @DisplayName("除法异常测试")
    void testDivideByZero() {
        assertThrows(IllegalArgumentException.class, () -> calculator.divide(1, 0), "除以0应抛出异常");
    }
}
