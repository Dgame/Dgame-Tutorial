import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic.Text;
import Dgame.System.Battery;
import Dgame.System.Font;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");
    
    Font fnt = Font("samples/font/arial.ttf", 22);
    Text curPower = new Text(fnt);
    curPower.setPosition(100, 200);

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
                    
                default: break;
            }
        }
        
        Battery battery = System.getBatteryInfo();
        
        curPower.format("%d seconds remain with %d %%. State: %s",
                        battery.seconds, battery.percent, battery.state);
        
        wnd.draw(curPower);
        
        wnd.display();
    }
}