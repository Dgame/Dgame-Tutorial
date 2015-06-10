import std.stdio;
import std.algorithm : filter, count;

import Dgame.Window;
import Dgame.Graphic;
import Dgame.Graphic.VertexArray;
import Dgame.Math;
import Dgame.System;

enum ubyte MAP_WIDTH = 12;
enum ubyte MAP_HEIGHT = 10;

enum ubyte TILE_SIZE = 32;
enum ubyte MOVE = TILE_SIZE;
enum ubyte ROTATION = 90;
enum ubyte GRAVITY = TILE_SIZE / 4;

enum ubyte MAX_FPS = 60;
enum ubyte TICKS_PER_FRAME = 1000 / MAX_FPS;

@nogc
bool isWalkable(const Rect[] quads, Sprite player) pure nothrow {
    const Vector2f edge_pos = player.getClipRect().getEdgePosition(Rect.Edge.BottomLeft);
    const Vector2i pos = edge_pos;

    foreach (ref const Rect quad; quads) {
        if (quad.getPosition() == pos)
            return true;
    }

    return false;
}

@nogc
bool gravityEffect(const Rect[] quads, Sprite player) pure nothrow {
    if (!isWalkable(quads, player)) {
        player.move(0, GRAVITY);

        return true;
    }

    return false;
}

void main() {
    Window wnd = Window(MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE, "Dgame Test");

    // 0 = empty, a = start, t = tile, z = target
    const char[MAP_WIDTH * MAP_HEIGHT] Tiles = [
        '0', 'a', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        '0', 't', 't', 't', 't', 't', '0', '0', 't', 't', 't', '0',
        '0', '0', '0', 't', 't', 't', 't', '0', '0', '0', '0', '0',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        't', 't', '0', '0', '0', '0', 't', 't', 't', 't', '0', 't',
        '0', '0', '0', '0', '0', 't', 't', 't', '0', '0', 't', 't',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        '0', 't', 't', 't', 't', '0', '0', '0', '0', '0', '0', '0',
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'z',
        '0', '0', '0', 't', 't', 't', 't', 't', 't', 't', 't', 't',
    ];

    Texture player_left_tex = Texture(Surface("Basti-Box_Left.png"));
    Texture player_right_tex = Texture(Surface("Basti-Box_Right.png"));
    Texture tile_tex = Texture(Surface("Tile.png"));

    Vector2f start, target;

    Rect[] quads;
    quads.reserve(Tiles[].filter!(a => a == 't').count());

    VertexArray va = new VertexArray(Geometry.Quads, tile_tex);

    ubyte x, y;
    foreach (ubyte idx, char c; Tiles) {
        if (Tiles[idx] == 't') {
            const Vector2f tilePos = Vector2f(x * TILE_SIZE, y * TILE_SIZE);
            const Rect texRect = Rect(0, 0, tile_tex.width, tile_tex.height);

            va.appendQuad(tilePos, texRect);
            quads ~= Rect(cast(int) tilePos.x, cast(int) tilePos.y, texRect.width, texRect.height);
        } else if (Tiles[idx] == 'a')
            start = Vector2f(x * TILE_SIZE, y * TILE_SIZE);
        else if (Tiles[idx] == 'z')
            target = Vector2f(x * TILE_SIZE, y * TILE_SIZE);

        x++;
        if (x >= MAP_WIDTH) {
            x = 0;
            y++;
        }
    }

    Sprite player = new Sprite(player_left_tex);
    player.setPosition(start);
    player.setRotationCenter(16, 16);

    Font fnt = Font("samples/font/arial.ttf", 12);
    Text fps = new Text(fnt);
    fps.setPosition(MAP_WIDTH * TILE_SIZE - 96, 4);

    StopWatch sw;
    StopWatch sw_fps;

    bool running = true;

    Event event;
    while (running) {
        wnd.clear();

        fps.format("FPS: %d", sw_fps.getCurrentFPS());

        immutable bool gravity = gravityEffect(quads, player);

        if (sw.getElapsedTicks() > TICKS_PER_FRAME) {
            sw.reset();

            while (wnd.poll(&event)) {
                switch (event.type) {
                    case Event.Type.Quit:
                        running = false;
                    break;
                        
                    case Event.Type.KeyDown:                        
                        if (event.keyboard.key == Keyboard.Key.Esc)
                            running = false;
                        else if (!gravity) {
                            switch (event.keyboard.key) {
                                case Keyboard.Key.Left:
                                    player.move(MOVE * -1, 0);
                                    player.rotate(ROTATION * -1);
                                    player.setTexture(player_left_tex);
                                break;
                                case Keyboard.Key.Right:
                                    player.move(MOVE, 0);
                                    player.rotate(ROTATION);
                                    player.setTexture(player_right_tex);
                                break;
                                default: break;
                            }
                        }
                    break;
                        
                    default: break;
                }
            }

            if (player.getPosition() == target) {
                wnd.push(Event.Type.Quit);
                writeln("You've won!");
            } else {
                const Vector2f pos = player.getPosition();
                if (pos.x > (MAP_WIDTH * TILE_SIZE) ||
                    pos.x < 0 ||
                    pos.y > (MAP_HEIGHT * TILE_SIZE) ||
                    pos.y < 0)
                {
                    writeln("You've lost!");
                    wnd.push(Event.Type.Quit);
                }
            }
        }

        wnd.draw(fps);
        wnd.draw(va);
        wnd.draw(player);

        wnd.display();
    }
}