package math;

public class Percentage {
    public static void main(String[] args) {
        double meal_cost = 12.00;
        int tip_percentage = 20;
        int tax_percentage = 8;
        System.out.println(meal_cost * tip_percentage / 100);
        System.out.println(meal_cost * tax_percentage / 100);
        double total_meal_cost = meal_cost * (1 + tip_percentage / 100.0 + tax_percentage / 100.0);
        System.out.println(total_meal_cost);
        System.out.println(Math.round(total_meal_cost));
    }
}
