// Source: https://www.patreon.com/posts/15944770

Shader "Custom/Snow"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_SnowAngle( "Snow Angle", Vector ) = ( 0.0, 0.0, 0.0, 0.0 )
		_SnowColour( "Snow Colour", Color ) = ( 0.0, 0.0, 0.0, 0.0 )
		_SnowExtrusionHeight( "Snow Extrusion Height", Range( 0,10 ) ) = 0.0
		_SnowSize( "Snow Size", Range( 0,10 ) ) = 0.0
		_RimPower( "Rim Power", Range( 0,10 ) ) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM

		#pragma surface surf Lambert vertex:vert

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
			float3 normal;
			float3 viewDir;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _SnowColour;
		fixed4 _SnowAngle;
		half _SnowExtrusionHeight;
		half _SnowSize;
		half _RimPower;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.normal = v.normal;

			float extrude = step( dot( v.normal, _SnowAngle.xyz ), _SnowSize );
			v.vertex.xyz += lerp( v.normal * _SnowExtrusionHeight, float3( 0.0, 0.0, 0.0 ), extrude );
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _SnowColour;
			o.Alpha = c.a;

			float col = step( dot( IN.normal, _SnowAngle.xyz ), _SnowSize );
			o.Albedo = lerp( _SnowColour, c.rgb, col );

			half rim = 1.0 - saturate( dot( normalize( IN.viewDir ), IN.normal ));
			o.Emission = _SnowColour * pow( rim, _RimPower );
		}
		ENDCG
	}
	FallBack "Diffuse"
}
