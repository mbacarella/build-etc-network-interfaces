open Core.Std

type t = 
  { name     : string
  ; essid    : string
  ; security : [ `None | `WEP of string | `WPA of string ] }
with sexp

let of_csv_line line =
  if line.[0] = '#'
  then `Comment line
  else
    let quote s =
    (* 2014-03-29 mbac: /etc/network/interfaces essids and keys should only
       be quoted if they have spaces.  Quoting strings that don't have spaces
       results in your essid being set to something ridiculous, like ""home"" *)
      if String.contains s ' ' then sprintf "\"%s\"" s
      else s
    in
    let name, essid, security =
      match String.split ~on:'|' line |> List.map ~f:String.strip with
      | [ name; essid ] -> name, essid, `None
      | [ name; essid; "wep"; wep_key ] -> name, essid, `WEP (quote wep_key)
      | [ name; essid; "wpa"; wpa_psk ] -> name, essid, `WPA (quote wpa_psk)
      | _ -> failwithf "unsupported format: %S" line ()
    in
    `Wifi_network { name; essid = quote essid; security }
    
let to_string t =
  let header = sprintf "iface wlan0_%s inet dhcp" t.name in
  let body =
    match t.security with
    | `None ->
      [ sprintf "wireless-essid %s" t.essid
      ; "wireless-mode managed"
      ; "wireless-channel auto" ]
    | `WEP key ->
      [ sprintf "wireless-essid %s" t.essid
      ; sprintf "wireless-key1 %s" key
      ; "wireless-defaultkey 1"
      ; "wireless-keymode open"
      ; "wireless-channel auto" ]
    | `WPA wpa_psk ->
      [ sprintf "wpa-ssid %s" t.essid
      ; sprintf "wpa-psk %s" wpa_psk ]
  in
  header ^ "\n  " ^ (String.concat ~sep:"\n  " body) ^ "\n"
