Shader "Unlit/DepthVisual"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 screenUV : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

			sampler2D _CameraDepthNormalsTexture;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenUV = ( ( o.vertex.xy / o.vertex.w ) + 1.0f ) / 2.0f;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float sampleSceneDepth = DecodeFloatRG( tex2D( _CameraDepthNormalsTexture, i.screenUV ).zw );
                return fixed4( sampleSceneDepth, sampleSceneDepth, sampleSceneDepth, 1.0f );
            }
            ENDCG
        }
    }
}
