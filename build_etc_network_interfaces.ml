open Core.Std

let preamble () =
  [ "# Generated file! Do not edit directly!"
  ; sprintf "# This was generated on %s by %s, using the command:"
      (Time.now () |> Time.to_string) (Sys.getenv_exn "USER")
  ; sprintf "# %s" (Array.to_list Sys.argv |> String.concat ~sep:" ")
  (* Not sure how much of this junk actually needs to be there. *)
  ; "auto lo"
  ; "iface lo inet loopback"
  ; "allow-hotplug eth0"
  ; "iface eth0 inet dhcp" ]

let main () =
  let cmd =
    Command.basic ~summary:"generate /etc/network/interfaces from simple csv"
      Command.Spec.( empty +> anon ("<PATH>" %: string) )
      (fun csv_path () ->
	List.iter (preamble ()) ~f:print_endline;
        In_channel.with_file csv_path ~f:In_channel.input_lines
	|> List.iter ~f:(fun line ->
          match Wifi_network.of_csv_line line with
	  | `Comment _ -> ()
	  | `Wifi_network wifi_network ->
	    print_endline (Wifi_network.to_string wifi_network)))
  in
  Command.run cmd

let () =
  Exn.handle_uncaught ~exit:true main
