import std.stdio;

import Dgame.Window;
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
                    
                    if (event.keyboard.key == Keyboard.Code.Esc)
                        running = false; // or: wnd.push(Event.Type.Quit);
                    
                break;
                    
                default: break;
            }
        }
        
        wnd.display();
    }
}