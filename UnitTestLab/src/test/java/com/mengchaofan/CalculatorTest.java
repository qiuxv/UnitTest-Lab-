package com.mengchaofan;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {
    private Calculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }

    @Test
    @DisplayName("验证标准加法运算")
    void testAdd() {
        assertEquals(5, calculator.add(2, 3), "2+3应等于5");
        assertEquals(-1, calculator.add(2, -3), "带负数的加法测试");
    }

    @Test
    @DisplayName("边界条件减法测试")
    void testSubtract() {
        assertAll("多场景减法验证",
            () -> assertEquals(5, calculator.subtract(8, 3)),
            () -> assertEquals(0, calculator.subtract(5, 5)),
            () -> assertEquals(10, calculator.subtract(5, -5))
        );
    }

    @Test
    @DisplayName("异常处理测试")
    void testSquareWithNull() {
        Exception exception = assertThrows(IllegalArgumentException.class, 
            () -> calculator.square(null));
        assertTrue(exception.getMessage().contains("输入不能为空"));
    }
}