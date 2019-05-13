using UnityEngine;

public class PixelationPP : PostProcess
{
    [SerializeField, Range(0.0f, 100.0f)] private float m_pixelation = 0.0f;

    private void Awake()
    {
        m_sourceMaterial = new Material(Shader.Find("Unlit/PixelEffect"));

        if (m_sourceMaterial.shader == null)
        {
            Debug.LogError("Failed to find shader");
        }
    }

    protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        base.OnRenderImage(source, destination);

        if (Enable && !Mathf.Approximately(m_pixelation, 0.0f))
        {
            m_sourceMaterial.SetFloat("_PixelSize", m_pixelation);
        }

        Graphics.Blit(source, destination, m_sourceMaterial);
    }
}