package com.mengchaofan;  // 包名必须与测试类路径一致

public class App {
    public static void main(String[] args) {
        Calculator calculator = new Calculator();
        System.out.println("2 + 3 = " + calculator.add(2, 3));
    }
}