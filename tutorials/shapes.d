import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System.Keyboard;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");
    
    Shape qs = new Shape(Geometry.Quads, 
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
    
    Shape many = new Shape(Geometry.Quads,
        [
            Vertex(55, 55),
            Vertex(60, 55),
            Vertex(60, 60),
            Vertex(55, 60),
            Vertex(15, 15),
            Vertex(20, 15),
            Vertex(20, 20),
            Vertex(15, 20),
            Vertex(30, 30),
            Vertex(35, 30),
            Vertex(35, 35),
            Vertex(30, 35),
            Vertex(40, 40),
            Vertex(45, 40),
            Vertex(45, 45),
            Vertex(40, 45)
        ]
    );
    many.fill = Shape.Fill.Full;
    many.setColor(Color4b.Red);

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
                    if (event.keyboard.key == Keyboard.Key.T) {
                        if (qs.geometry == Geometry.Quads)
                            qs.geometry = Geometry.Triangles;
                        else
                            qs.geometry = Geometry.Quads;
                    } else if (event.keyboard.key == Keyboard.Key.Space)
                        circle.move(4, -4);
                    break;
                    
                default: break;
            }
        }
        
        wnd.draw(qs);
        wnd.draw(many);
        wnd.draw(circle);
        
        wnd.display();
    }
}