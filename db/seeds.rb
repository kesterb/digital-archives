User.find_or_create_by!(email: "joelf@osfashland.org") { |user| user.password = "osfarchive2015"; user.display_name = "Joel Ferrier"; user.group_list = "admin" }
User.find_or_create_by!(email: "mariad@osfashland.org") { |user| user.password = "osfarchive2015"; user.display_name = "Maria Deweerdt"; user.group_list = "admin" }
User.find_or_create_by!(email: "debrag@osfashland.org") { |user| user.password = "osfarchive2015"; user.display_name = "Debra Griffith"; user.group_list = "admin" }

User.find_or_create_by!(email: "trever@codingzeal.com") { |user| user.password = "osfarchive2015"; user.display_name = "Trever Yarrish"; user.group_list = "admin"}
User.find_or_create_by!(email: "jeff.parr@codingzeal.com") { |user| user.password = "osfarchive2015"; user.display_name = "Jeff Parr"; user.group_list = "admin"}
User.find_or_create_by!(email: "sean.culver@codingzeal.com") { |user| user.password = "osfarchive2015"; user.display_name = "Sean Culver"; user.group_list = "admin" }

ProductionCredits::Engine.load_seed
