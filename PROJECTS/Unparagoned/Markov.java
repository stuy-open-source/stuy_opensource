import java.util.ArrayList;

public class Markov{

	private String _substring;
	private ArrayList<String> _array; //stores subsequent Markovs

	//constructor
	public Markov(String substring){
		_substring = substring;
		_array = new ArrayList<String>();
	}


	//accessors
	public ArrayList<String> getArray(){
		return _array;
	}

	public int getFrequency(){
		return _array.size();
	}

	public String getSubstring(){
		return _substring;
	}

	//mutators
	//adds subsequent Markovs to _
	public void add(String x){
		_array.add(x);
	}

	public String toString(){
		String output = _substring + " : [";
		for (String s : _array){
			output += " " + s + ",";
		}
		output = output.substring(0,output.length()-1);
		output += "]";
		return output;
	}

}
