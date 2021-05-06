﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Raymarching/01.SimpleSphere"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
                return o;
            }

            #define STEPS 64
            #define STEP_SIZE 0.01

            bool SphereHit(float3 pos, float3 center, float radius)
            {
                return distance(pos, center) < radius;
            }

            float RaymarchHit(float3 pos, float3 dir)
            {
                for (int i = 0; i < STEPS; i++)
                {
                    if (SphereHit(pos, float3(0, 0, 0), 0.5))
                        return pos;

                    pos += dir * STEP_SIZE;
                }

                return 0;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPos = i.wPos;
                float depth = RaymarchHit(worldPos, viewDirection);

                if (depth != 0)
                    return fixed4(1, 0, 0, 1);
                else
                    return fixed4(1, 1, 1, 0);
            }
            ENDCG
        }
    }
}