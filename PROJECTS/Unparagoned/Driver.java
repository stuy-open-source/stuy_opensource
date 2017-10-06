import java.util.*;

public class Driver{

  public static void main(String[] args){
    go();
  }

  public static void go(){

    Scanner s = new Scanner(System.in);
    String[] input = requestFile(s);
    int len = input.length;
    int k = requestK(s, len);
    Hashtable<String,Markov> hash = Processor.process(k,input);

    // creates initial starting point for output
    String [] beg = new String[k];
    for (int i = 0; i < k; i++){
      beg[i] = input[i];
    }

    String output = Generator.generate(k,hash,beg,len);
    System.out.println(output);


    System.out.print("Type N to model a new file, type END to end program: ");
    String ans = s.next();
    if (ans.equals("N")){
      go();
    }
    else if (ans.equals("END")){
      return;
    }
    else{
      System.out.println("Invalid entry. Program will end.");
      return;
    }
  }



  // asks user for the file and converts it into a string
  public static String[] requestFile(Scanner s){

    System.out.print("Enter the file name: ");

    String fileName = s.next();
    String[] input = ReadFile.readFileArray(fileName);

    // null input means that the file does not exist; asks for another file
    while (input == null){
      System.out.print("File not found. Enter another file name: ");
      fileName = s.next();
      input = ReadFile.readFileArray(fileName);
    }

    return input;
  }

  // asks user for constant k to process string
  public static int requestK(Scanner s, int len){
    System.out.print("Enter processing constant (a larger value will decrease variability; the minimum value is 1): ");
    int k;
    do{
      try{
        String kString = s.next();
        k = Integer.parseInt(kString);
        break;
      } catch (Exception e){
        System.out.print("Input must be an integer. Enter another processing constant (a larger value will decrease variability): ");
      }
    } while (true);
    // check size of k; asks for another k if greater than length
    while (k > len || k < 0){
     System.out.print("Constant exceeds text length or is less than 0. Enter another processing constant (a larger value will decrease variability): ");
     k = s.nextInt();
    }
    return k;
  }


}
