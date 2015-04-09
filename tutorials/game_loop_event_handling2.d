import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.System.Keyboard;

void main() {
	Window wnd = Window(640, 480, "Dgame Test");

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
					writeln("Pressed key ", event.keyboard.key);
					
					if (event.keyboard.key == Keyboard.Key.Esc)
						running = false; // or: wnd.push(Event.Type.Quit);
					
				break;
					
				case Event.Type.MouseButtonDown:
					writefln("Mouse down at %d:%d", event.mouse.button.x, event.mouse.button.y);
				break;
					
				case Event.Type.MouseMotion:
					writefln("Mouse moved to %d:%d. Relative to %d:%d.",
					         event.mouse.motion.x, event.mouse.motion.y,
					         event.mouse.motion.rel_x, event.mouse.motion.rel_y);
				break;

				case Event.Type.MouseWheel:
					writefln("Mouse wheel to %d:%d.", event.mouse.wheel.x, event.mouse.wheel.y);
				break;
					
				default: break;
			}
		}
		
		wnd.display();
	}
}