
#version 330 core
layout (location = 0) out vec4 FragColor;

uniform vec3 lightColor;

void main()
{
    //自发光的箱子
    FragColor = vec4(lightColor, 1.0);
}
