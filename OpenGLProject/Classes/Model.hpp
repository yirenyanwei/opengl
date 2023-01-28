//
//  Model.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/5/16.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Model_hpp
#define Model_hpp

#include <stdio.h>
#include <vector>
#include <iostream>
#include <map>
#include "Shader.hpp"
#include "Mesh.hpp"
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include "stb_image.h"
using namespace std;

class Model{
public:
    /*  函数   */
    Model(string const &path);
    Model();
    ~Model();
    inline vector<Mesh> getMeshes()
    {
        return meshes;
    }
    inline map<string, Texture> getTexturesLoaded()
    {
        return textures_loaded;
    }
    void Draw(Shader shader);
private:
    /*  模型数据  */
    vector<Mesh> meshes;
    string directory;
    map<string, Texture> textures_loaded;
    /*  函数   */
    void loadModel(string path);
    void processNode(aiNode *node, const aiScene *scene);
    Mesh processMesh(aiMesh *mesh, const aiScene *scene);
    vector<Texture> loadMaterialTextures(aiMaterial *mat, aiTextureType type,
                                         string typeName);
    unsigned int TextureFromFile(const char *path, const string &directory, bool gamma = false);
};

#endif /* Model_hpp */
