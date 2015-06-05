import std.stdio;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.Graphic;
import Dgame.Math;

void main() {
    Window wnd = Window(640, 480, "Dgame Test");

    Surface wiki_srfc = Surface("samples/images/wiki.png");
    Texture wiki_tex = Texture(wiki_srfc);
    
    Shape texQuad = new Shape(
        Geometry.Quads,
        [
            Vertex(  0,  0),
            Vertex(140,  0),
            Vertex(140, 140),
            Vertex(  0, 140)
        ]
    );
    texQuad.setTexture(&wiki_tex);
    texQuad.setColor(Color4b.Green.withTransparency(125));
    texQuad.setPosition(200, 100);
    texQuad.setRotation(25);

    Shape texCircle = new Shape(50, Vector2f(50, 50));
    texCircle.setTexture(&wiki_tex);
    texCircle.setTextureRect(Rect(25, 25, 100, 100));
    texCircle.setColor(Color4b.White);
    texCircle.move(400, 300);
    texCircle.setRotation(25);

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
        
        wnd.draw(texQuad);
        wnd.draw(texCircle);
        
        wnd.display();
    }
}