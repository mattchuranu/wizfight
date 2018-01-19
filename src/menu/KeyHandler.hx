package menu;

import com.haxepunk.utils.Key;

class KeyHandler {
	public function handleKey(key:Int):String {
		var string = "";

		switch (key) {
			case Key.A:
				string += "A";
			case Key.B:
				string += "B";
			case Key.C:
				string += "C";
			case Key.D:
				string += "D";
			case Key.E:
				string += "E";
			case Key.F:
				string += "F";
			case Key.G:
				string += "G";
			case Key.H:
				string += "H";
			case Key.I:
				string += "I";
			case Key.J:
				string += "J";
			case Key.K:
				string += "K";
			case Key.L:
				string += "L";
			case Key.M:
				string += "M";
			case Key.N:
				string += "N";
			case Key.O:
				string += "O";
			case Key.P:
				string += "P";
			case Key.Q:
				string += "Q";
			case Key.R:
				string += "R";
			case Key.S:
				string += "S";
			case Key.T:
				string += "T";
			case Key.U:
				string += "U";
			case Key.V:
				string += "V";
			case Key.W:
				string += "W";
			case Key.X:
				string += "X";
			case Key.Y:
				string += "Y";
			case Key.Z:
				string += "Z";
		}

		return string;
	}
}