{{ with .Get 0 }}
  {{ $l := index $.Site.Data.ipa . }}
    {{ if $l }}
      [<a href="{{ $l }}"> {{ . }} </a>]
    {{ else }}
      [{{ . }}]
    {{ end }}
{{ end }}
