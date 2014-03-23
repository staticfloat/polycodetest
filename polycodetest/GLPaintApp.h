//
//  GLPaint.h
//  polycodetest
//
//  Created by Elliot Saba on 3/8/14.
//  Copyright (c) 2014 Elliot Saba. All rights reserved.
//

#ifndef __polycodetest__GLPaintApp__
#define __polycodetest__GLPaintApp__

#include <Polycode.h>
#include "PolycodeView.h"

using namespace Polycode;

class GLPaintApp : public EventHandler {
public:
    GLPaintApp(PolycodeView *view);
    ~GLPaintApp();
    bool Update();
    void handleEvent(Event *e);
    
    void createFPS();
    void updateFPS();
    
    void createGrid();
    void updateGrid();
    
    void createShaderMesh();
private:
	Core *core;
    Scene *scene;
    Scene *hud;
    
    // FPS stuff
    SceneLabel * fpsLabel;
    double lastCallTime;
    double currFPS;
    
    // Grid stuff
    SceneMesh * grid;
    
    // Shader mesh stuff
    SceneMesh * shaderMesh;
    Shader * shader;
    
    // Mouse stuff
    bool dragging;
    Vector2 lastMousePos;
};


#endif /* defined(__polycodetest__GLPaint__) */
