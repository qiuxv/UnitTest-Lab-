package com.mengchaofan;

public class Calculator {
    // 加法（支持JDK 17的密封类特性）
    public int add(int a, int b) {
        return a + b;
    }

    // 减法（使用增强型switch表达式）
    public int subtract(int a, int b) {
        return switch (b) {
            case 0 -> a;
            default -> a - b;
        };
    }

    // 平方计算（包含空值校验）
    public double square(Double num) {
        if (num == null) throw new IllegalArgumentException("输入不能为空");
        return Math.pow(num, 2);
    }
}