package com.mengchaofan;  // 包名必须与业务类一致

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
    @DisplayName("测试加法运算")
    void testAdd() {
        assertEquals(5, calculator.add(2, 3));
    }

    @Test
    @DisplayName("测试非法参数异常")
    void testAddWithInvalidArgs() {
        // 使用对象参数方法
        assertThrows(IllegalArgumentException.class, () -> calculator.add("invalid", 3));
    }
}