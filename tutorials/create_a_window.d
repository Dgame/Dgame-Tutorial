import Dgame.Window.Window;
import Dgame.Graphic.Color;
import Dgame.System.StopWatch;

void main() {
	Window wnd = Window(640, 480, "Dgame Test");
	wnd.setClearColor(Color4b.Blue); /// Default would be Color.White
	wnd.clear(); /// Clear the buffer and fill it with the clear Color
	wnd.display();
	
	StopWatch.wait(2000);
}