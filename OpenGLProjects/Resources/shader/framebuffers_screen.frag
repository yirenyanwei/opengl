#version 330 core
out vec4 FragColor;

in vec2 TexCoords;//代表一个纹理坐标(s,t,p,q)

uniform sampler2D screenTexture;

const float offset = 1.0 / 300.0;
float kernelSharpen[9] = float[](
    -1, -1, -1,
    -1,  9, -1,
    -1, -1, -1
);
float kernelSharpen2[9] = float[](
    -1, -1, -1,
    -1,  9, -1,
    -1, -1, -1
);
float kernelBlur[9] = float[](
    1.0 / 16, 2.0 / 16, 1.0 / 16,
    2.0 / 16, 4.0 / 16, 2.0 / 16,
    1.0 / 16, 2.0 / 16, 1.0 / 16
);

vec4 createEffect(float kernel[9])
{
    vec2 offsets[9] = vec2[](
        vec2(-offset,  offset), // 左上
        vec2( 0.0f,    offset), // 正上
        vec2( offset,  offset), // 右上
        vec2(-offset,  0.0f),   // 左
        vec2( 0.0f,    0.0f),   // 中
        vec2( offset,  0.0f),   // 右
        vec2(-offset, -offset), // 左下
        vec2( 0.0f,   -offset), // 正下
        vec2( offset, -offset)  // 右下
    );

    vec3 sampleTex[9];
    for(int i = 0; i < 9; i++)
    {
        sampleTex[i] = vec3(texture(screenTexture, TexCoords.st + offsets[i]));
    }
    vec3 col = vec3(0.0);
    for(int i = 0; i < 9; i++)
        col += sampleTex[i] * kernel[i];
    vec4 result = vec4(col, 1.0);
    return result;
}

void main()
{
    //正常
    vec3 col = texture(screenTexture, TexCoords).rgb;
    FragColor = vec4(col, 1.0);
    
    // 反相
//    FragColor = vec4(vec3(1.0 - texture(screenTexture, TexCoords)), 1.0);
    
    //变灰
//    FragColor = texture(screenTexture, TexCoords);
//    float average = 0.2126 * FragColor.r + 0.7152 * FragColor.g + 0.0722 * FragColor.b;
//    FragColor = vec4(average, average, average, 1.0);
    
    //锐化
//    FragColor = createEffect(kernelSharpen);
    
    //模糊
//    FragColor = createEffect(kernelBlur);
    
    //这个核高亮了所有的边缘，而暗化了其它部分
//    FragColor = createEffect(kernelSharpen2);
} 
