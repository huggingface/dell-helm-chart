{{- define "instances" -}}

{{/* Define the instances with their GPU IDs and providers. 
Model config validation is handled in the DEH portal UI/SDK/CLI. */}}
{{- $instances := dict 
  "xe9680-nvidia-h100" (dict
    "gpuId" "NVIDIA-H100-80GB-HBM3"
    "provider" "nvidia"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
  "xe9680-amd-mi300x" (dict
    "gpuId" "AMD-MI300X-192GB-HBM3"
    "provider" "amd"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
  "xe9680-intel-gaudi3" (dict
    "gpuId" "INTEL-GAUDI3-192GB-HBM3"
    "provider" "intel"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
  "xe8640-nvidia-h100" (dict
    "gpuId" "NVIDIA-H100-80GB-HBM3"
    "provider" "nvidia"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
  "r760xa-nvidia-h100" (dict
    "gpuId" "NVIDIA-H100-PCIe"
    "provider" "nvidia"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
  "r760xa-nvidia-l40s" (dict
    "gpuId" "NVIDIA-L40S"
    "provider" "nvidia"
    "gpus" (list (int 1) (int 2) (int 4) (int 8))
  )
-}}

{{/* `toYaml` preserves the integer values for e.g. the `numGpus`, whilst `toJson` does not */}}
{{- toYaml $instances -}}

{{- end -}}