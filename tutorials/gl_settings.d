import std.stdio;

import Dgame.Window;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System;

void main() {
    const GLContextSettings gl_context_settings = GLContextSettings(GLContextSettings.AntiAlias.None, GLContextSettings.Version.GL30);
    
    Window wnd = Window(640, 480, "Dgame Test", Window.Style.Default);//, gl_context_settings);
    wnd.setVerticalSync(Window.VerticalSync.Enable);
    wnd.setClearColor(Color4b.Gray);

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
        wnd.draw(circle);
        
        wnd.display();
    }
}