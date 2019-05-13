// Source: https://www.patreon.com/posts/fun-with-stencil-26211104

Shader "Unlit/PixelEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	    _PixelSize( "Pixel width", float ) = 1.0
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			half _PixelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 pixels = _PixelSize * ( 1 / _ScreenParams.xy );
				float2 pixeluv = float2( pixels * round( i.uv / pixels ) );

				// sample the texture
				fixed4 col = tex2D( _MainTex, pixeluv );
				// apply fog
				UNITY_APPLY_FOG( i.fogCoord, col );
				return col;
			}
			ENDCG
		}
	}
}
