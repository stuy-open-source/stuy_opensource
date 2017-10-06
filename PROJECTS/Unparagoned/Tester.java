//this is where you can check any of the methods

public class Tester{

    public static void main(String [] args){

	Markov testM = new Markov("aa");
	testM.add(); //make sure that add works. This is why aa is 2
	
	Entry one = new Entry("c");
	Entry two = new Entry("d");
	Entry three = new Entry("e");
	Entry four = new Entry("c");
	
	testM.addToArray(one);
	testM.addToArray(two);
	testM.addToArray(three);
	testM.addToArray(four);
        
	//testM.getArray().get(0).addFrequency(); Make sure that addFrequency() works
	System.out.println(testM.toString());
    }
}
