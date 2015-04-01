import std.stdio;

import Dgame.Window;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System;

void main() {
    Window wnd = Window(640, 480, "Dgame Test", Window.Style.Default, GLSettings(0, 0, 8));
    wnd.setVerticalSync(Window.VerticalSync.Enable);
    wnd.setClearColor(Color4b.Gray);

    Shape qs = new Shape(Geometry.Quad, 
        [
            Vertex( 75,  75),
            Vertex(275,  75),
            Vertex(275, 275),
            Vertex( 75, 275)
        ]
    );
    
    qs.fill = Shape.Fill.Full;
    qs.setColor(Color4b.Blue);
    qs.setPosition(200, 50);
    
    Shape circle = new Shape(25, Vector2f(180, 380));
    circle.setColor(Color4b.Green);
    circle.setPosition(150, -100);

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
                    if (event.keyboard.key == Keyboard.Code.T) {
                        if (qs.geometry == Geometry.Quad)
                            qs.geometry = Geometry.Triangle;
                        else
                            qs.geometry = Geometry.Quad;
                    } else if (event.keyboard.key == Keyboard.Code.Space)
                        circle.move(4, -4);
                    break;
                    
                default: break;
            }
        }
        
        wnd.draw(qs);
        wnd.draw(circle);
        
        wnd.display();
    }
}