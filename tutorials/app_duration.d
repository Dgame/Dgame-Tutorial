import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.System.StopWatch;

void main() {
	Window wnd = Window(640, 480, "Dgame Test");

	StopWatch clock;

	bool running = true;

	Event event;
	while (running) {
		wnd.clear();
		
		while (wnd.poll(&event)) {
			switch (event.type) {
				case Event.Type.Quit:
					writeln("Quit Event");
					running = false;
				break;
					
				case Event.Type.KeyDown:
					Time time = clock.getTime();
					writefln("Game Loop runs now for %d ms - %f secs - %f min",
					         time.msecs, time.seconds, time.minutes);
				break;
					
				default: break;
			}
		}
		
		wnd.display();
	}
}