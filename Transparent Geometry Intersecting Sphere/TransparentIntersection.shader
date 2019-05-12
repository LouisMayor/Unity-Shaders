// Source: https://www.youtube.com/watch?v=C6lGEgcHbWc

Shader "Unlit/TransparentIntersection"
{
	Properties
	{
		_MainTex( "Texture", 2D ) = "white" {}
		_Colour ("Colour", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{

		Blend One One
		ZWrite Off
		Cull Off

		Tags
	    {
		    "RenderType" = "Transparent"
			"Queue" = "Transparent"
	    }
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
				float vertexDepth : DEPTH;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			fixed4 _Colour;
			sampler2D _CameraDepthNormalsTexture;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;

				o.uv = TRANSFORM_TEX( v.uv, _MainTex );
				o.vertex = UnityObjectToClipPos( v.vertex );

				o.screenUV = ( ( o.vertex.xy / o.vertex.w ) + 1.0f ) / 2.0f;
				o.screenUV.y = 1.0f - o.screenUV.y;
				o.vertexDepth = -UnityObjectToViewPos( v.vertex ).z * _ProjectionParams.w;

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float sampleSceneDepth = DecodeFloatRG(tex2D( _CameraDepthNormalsTexture, i.screenUV).zw);
			    float depthDiff = sampleSceneDepth - i.vertexDepth;

				float intersect = step( depthDiff, 0.0f );
				float intersection = lerp( 1.0f - smoothstep( 0.0f, _ProjectionParams.w * 0.5f, depthDiff ), 0.0f, intersect );

				fixed4 col = _Colour * _Colour.a + intersection;
				return col;
			}
			ENDCG
		}
	}
}
