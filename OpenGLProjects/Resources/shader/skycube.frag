#version 330 core
out vec4 FragColor;

in vec3 Normal;
in vec3 Position;
in VS_OUT
{
    vec3 normal;
    vec3 position;
} fs_in;

uniform vec3 cameraPos;
uniform samplerCube skybox;

void main()
{
    //正常
//    FragColor = vec4(texture(skybox, Position).rgb, 1.0);
    //反射
    vec3 I = normalize(Position - cameraPos);
    vec3 R = reflect(I, normalize(Normal));
    FragColor = vec4(texture(skybox, R).rgb, 1.0);
    //折射
//    float ratio = 1.00 / 1.52;
//    vec3 I = normalize(Position - cameraPos);
//    vec3 R = refract(I, normalize(Normal), ratio);
//    FragColor = vec4(texture(skybox, R).rgb, 1.0);
    
    //gl_FragCoord x和y分量是片段的窗口空间(Window-space)坐标  z为深度测试
//    if(gl_FragCoord.x<400){
//        FragColor = vec4(1.0, 0, 0, 1);
//    }else {
//        FragColor = vec4(0, 1.0, 0, 1);
//    }
    
    //gl_FrontFacing变量是一个bool 如果当前片段是正向面的一部分那么就是true，否则就是false
//    if(gl_FrontFacing) {
//        FragColor = vec4(1.0, 0, 0, 1);
//    }else {
//        FragColor = vec4(0, 1.0, 0, 1);
//    }
    
    
}
