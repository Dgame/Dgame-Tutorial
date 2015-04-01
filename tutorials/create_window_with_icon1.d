import Dgame.Window.Window;
import Dgame.Graphic.Surface;
import Dgame.System.StopWatch;

void main() {
	Window wnd = Window(640, 480, "Dgame Test");
	Surface icon = Surface("samples/images/OK-icon.png");
	wnd.setIcon(icon);
	wnd.clear();
	wnd.display();
	
	StopWatch.wait(2000);
}