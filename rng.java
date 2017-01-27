public class rng {
    public static void gen10(){
	double r = 2.8;
	double input = 0.5;
        double output = 0;
	while (r < 4){
	    output = (r * input) * (1 - input);
	    System.out.println(output * 100);
	    input = output;
	    r += 0.001;
	}
    }

    public static void main(String[] args){
	gen10();
    }
}
