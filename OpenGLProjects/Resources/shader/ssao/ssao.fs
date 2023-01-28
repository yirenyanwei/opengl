#version 330 core
out float FragColor;

in vec2 TexCoords;

//使用GBuffer
uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D texNoise;

//半球采样核心点
uniform vec3 samples[64];

// parameters (you'd probably want to use them as uniforms to more easily tweak the effect)
int kernelSize = 4;//64样本值的采样核心： 太卡了，先k改小点
float radius = 0.5;//球半径
float bias = 0.025;

// tile noise texture over screen based on screen dimensions divided by noise size
//// 屏幕的平铺噪声纹理会根据屏幕分辨率除以噪声大小的值来决定
const vec2 noiseScale = vec2(800.0/4.0, 600.0/4.0);

uniform mat4 projection;

void main()
{
    // get input for SSAO algorithm
    vec3 fragPos = texture(gPosition, TexCoords).xyz;
    vec3 normal = normalize(texture(gNormal, TexCoords).rgb);
    //朝向切线空间平面法线的随机旋转向量
    vec3 randomVec = normalize(texture(texNoise, TexCoords * noiseScale).xyz);
    // create TBN change-of-basis matrix: from tangent-space to view-space
    //空间转换 向量从切线空间变换到观察空间  TBN
    vec3 tangent = normalize(randomVec - normal * dot(randomVec, normal));
    vec3 bitangent = cross(normal, tangent);
    mat3 TBN = mat3(tangent, bitangent, normal);
    // iterate over the sample kernel and calculate occlusion factor
    float occlusion = 0.0;
    for(int i = 0; i < kernelSize; ++i)
    {
        // get sample position
        vec3 samplePos = TBN * samples[i]; // from tangent to view-space  世界坐标系
        samplePos = fragPos + samplePos * radius;//radius乘上偏移样本来增加(或减少)SSAO的有效取样半径
        
        // project sample position (to sample texture) (to get position on screen/texture)
        //变换sample到屏幕空间
        vec4 offset = vec4(samplePos, 1.0);
        offset = projection * offset; // from view to clip-space
        offset.xyz /= offset.w; // perspective divide
        offset.xyz = offset.xyz * 0.5 + 0.5; // transform to range 0.0 - 1.0
        
        // get sample depth 样本深度
        float sampleDepth = texture(gPosition, offset.xy).z; // get depth value of kernel sample
        
        // range check & accumulate
        //我们引入一个范围测试从而保证我们只当被测深度值在取样半径内时影响遮蔽因子
        float rangeCheck = smoothstep(0.0, 1.0, radius / abs(fragPos.z - sampleDepth));
        occlusion += (sampleDepth >= samplePos.z + bias ? 1.0 : 0.0) * rangeCheck;
    }
    //我们需要将遮蔽贡献根据核心的大小标准化，并输出结果。注意我们用1.0减去了遮蔽因子，以便直接使用遮蔽因子去缩放环境光照分量。
    //遮蔽因子是算阴影的，它越大，光的颜色越小
    occlusion = 1.0 - (occlusion / kernelSize);
    
    FragColor = occlusion;
}
