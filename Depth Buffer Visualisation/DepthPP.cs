using UnityEngine;

public class DepthPP : PostProcess
{
    [SerializeField] private Camera m_camera;
    [SerializeField, Range(1.0f, 100.0f)] private float m_farclip = 10.0f;

    private float m_previousFarClip;
    private float m_previousSampledFarClip;

    private void Awake()
    {
        m_sourceMaterial = new Material(Shader.Find("Unlit/DepthVisual"));

        if(m_sourceMaterial.shader == null)
        {
            Debug.LogError("Failed to find shader");
        }

        m_camera = GetComponent<Camera>();

        if(m_camera == null)
        {
            Debug.LogError("Failed to find a camera");
        }
    }

    private void OnEnable()
    {
        m_previousFarClip = m_camera.farClipPlane;
        UpdateFarClip(m_farclip);
    }

    private void OnDisable()
    {
        UpdateFarClip(m_previousFarClip);
    }

    private void UpdateFarClip(float fc)
    {
        m_camera.farClipPlane = fc;
        m_previousSampledFarClip = fc;
    }

    private void Update()
    {
        if (!Mathf.Approximately(m_farclip, m_previousSampledFarClip))
        {
            UpdateFarClip(m_farclip);
        }
    }

    protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        base.OnRenderImage(source, destination);
        Graphics.Blit(source, destination, m_sourceMaterial);
    }
}