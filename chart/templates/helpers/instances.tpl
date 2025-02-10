{{- define "instances" -}}

{{- $instances := dict
  "xe9680-nvidia-h100" (dict
    "provider" "nvidia"
    "gpus" (list
      (int 1)
      (int 4)
      (int 8)
    )
    "models" (dict
      "deepseek-ai/deepseek-r1-distill-llama-70b" (list 4 8)
      "meta-llama/meta-llama-3-70b-instruct" (list 4 8)
    )
    "nodeSelector" (dict
      "nvidia.com/gpu.product" "NVIDIA-H100-80GB-HBM3"
    )
  )
  "xe9680-amd-mi300x" (dict
    "provider" "amd"
    "gpus" (list
      (int 1)
      (int 4)
      (int 8)
    )
    "models" (dict
      "deepseek-ai/deepseek-r1-distill-llama-70b" (list 4 8)
      "meta-llama/meta-llama-3-70b-instruct" (list 4 8)
    )
  )
-}}

{{/* `toYaml` preserves the integer values for e.g. the `numGpus`, whilst `toJson` does not */}}
{{- toYaml $instances -}}

{{- end -}}
