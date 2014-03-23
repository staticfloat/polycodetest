//
//  GLPaint.cpp
//  polycodetest
//
//  Created by Elliot Saba on 3/8/14.
//  Copyright (c) 2014 Elliot Saba. All rights reserved.
//

#include "GLPaintApp.h"
#include "Polycode2DPhysics.h"
#include <string.h>

#define XRES                1280
#define YRES                720
#define ASPECT              ((float)XRES/YRES)
#define GRID_SIZE           100
#define FPS_LABEL_HEIGHT    28


GLPaintApp::GLPaintApp(PolycodeView *view) {
	core = new POLYCODE_CORE(view, XRES, YRES, false, true, 0, 0, 60, -1, true);
    hud = new Scene(Scene::SCENE_2D);
    hud->getActiveCamera()->setOrthoSize(XRES, YRES);
    
    scene = new Scene(Scene::SCENE_2D);
    scene->getActiveCamera()->setOrthoSize(XRES, YRES);

    // Register at least one font for our poor, poor program.  :)
    CoreServices::getInstance()->getResourceManager()->addDirResource("Resources", false);
    
    createGrid();
    updateGrid();
    createFPS();
    updateFPS();
    createShaderMesh();
    
    // Initialize!!! INITIALIZE!!!
    dragging = false;
    
    core->getInput()->addEventListener(this, InputEvent::EVENT_MOUSEMOVE);
	core->getInput()->addEventListener(this, InputEvent::EVENT_MOUSEDOWN);
	core->getInput()->addEventListener(this, InputEvent::EVENT_MOUSEUP);
}

GLPaintApp::~GLPaintApp() {
}

void GLPaintApp::createGrid() {
    grid = new SceneMesh(Mesh::LINE_MESH);
    grid->setColor(1, 1, 1, .2);
    scene->addChild(grid);
}

void GLPaintApp::updateGrid() {
    Mesh * m = grid->getMesh();
    m->clearMesh();
    Vector2 center = scene->getActiveCamera()->getPosition2D();
    
    for( int xi=0; xi<=XRES/GRID_SIZE; ++xi ) {
        double xpos = ((int)(center.x - XRES/2)/GRID_SIZE + xi)*GRID_SIZE;
        m->addVertex( xpos,  YRES/2 + center.y, 0 );
        m->addVertex( xpos, -YRES/2 + center.y, 0);
    }
    for( int yi=0; yi<=YRES/GRID_SIZE; ++yi ) {
        double ypos = ((int)(center.y - YRES/2)/GRID_SIZE + yi)*GRID_SIZE;
        m->addVertex(  XRES/2 + center.x, ypos, 0 );
        m->addVertex( -XRES/2 + center.x, ypos, 0);
    }
    
    // Add a little circle at the origin
    for( double theta = 0; theta <= 2*PI; theta += PI/32.0 ) {
        m->addVertex( GRID_SIZE/6*sin(theta), GRID_SIZE/6*cos(theta), 0 );
        m->addVertex( GRID_SIZE/6*sin(theta + PI/32.0), GRID_SIZE/6*cos(theta + PI/32.0), 0 );
    }
}

void GLPaintApp::createFPS() {
    fpsLabel = new SceneLabel("FPS: 0", FPS_LABEL_HEIGHT);
	hud->addChild(fpsLabel);
    currFPS = 0;
}

void GLPaintApp::updateFPS() {
    char buff[100];
    snprintf(buff, 100, "%.1f", currFPS);
    fpsLabel->setText(buff);

    Vector2 fps_pos = hud->getActiveCamera()->getPosition2D();
    fps_pos.x -= (XRES - fpsLabel->getTextWidthForString(buff) - 8)/2.0;
    fps_pos.y += (YRES - FPS_LABEL_HEIGHT)/2;
    fpsLabel->setPosition( fps_pos.x, fps_pos.y, 0 );
}

void GLPaintApp::createShaderMesh() {
    shaderMesh = new SceneMesh(Mesh::LINE_STRIP_MESH);
    Mesh * m = shaderMesh->getMesh();
    
    int N = 64;
    for( int i=0; i<=N; ++i ) {
        double r = GRID_SIZE*exp(-i*4.0/N);
        m->addVertex( r*sin(PI*i/N - PI/3), r*cos(PI*i/N - PI/3), 0 );
    }
    shaderMesh->setColor(1, 1, 1, 1);
    shaderMesh->setPosition(GRID_SIZE*3, 0);
    
    /**/
    shaderMesh->setMaterialByName("paintmat");
    Material * mat = shaderMesh->getMaterial();
    ShaderBinding * sb = mat->getShaderBinding(0);
    
    Renderer * r = CoreServices::getInstance()->getRenderer();
    Matrix4 MV = r->getModelviewMatrix();
    Matrix4 P = r->getProjectionMatrix();
    Matrix4 MVP = r->getModelviewMatrix() * r->getProjectionMatrix();
    sb->addParam(ProgramParam::PARAM_MATRIX, "MVP")->setMatrix4(MVP);
    
    scene->addChild(shaderMesh);
    /**/
}

bool GLPaintApp::Update() {
    double nowTime = [[NSDate date] timeIntervalSinceReferenceDate];
    currFPS = currFPS*.93 + .07/(nowTime - lastCallTime);
    lastCallTime = nowTime;

    updateFPS();
    return core->updateAndRender();
}

void GLPaintApp::handleEvent(Event *e) {
    Camera * cam = scene->getActiveCamera();
	if(e->getDispatcher() == core->getInput()) {
		InputEvent *inputEvent = (InputEvent*)e;
		switch(e->getEventCode()) {
			case InputEvent::EVENT_MOUSEMOVE:
                if( dragging) {
                    Vector2 pos = lastMousePos - inputEvent->getMousePosition();
                    cam->Translate( pos.x, -pos.y );
                    updateFPS();
                    updateGrid();
                }
                lastMousePos = inputEvent->getMousePosition();
                break;
			case InputEvent::EVENT_MOUSEDOWN:
                dragging = true;
                break;
			case InputEvent::EVENT_MOUSEUP:
                dragging = false;
                break;
		}
    }
}