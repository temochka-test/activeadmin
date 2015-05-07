module  ActiveAdmin

    module  Generators

        class  Boilerplate

            def  initialize(class_name)

                @class_name  =  class_name

            end



            def  attributes

                @class_name.constantize.new.attributes.keys

            end



            def  rows

                attributes.map  {  |a|  row(a)  }.join("\n")

            end



            def  row(name)

                "#      row  :#{name.gsub(/_id$/,  '')}"

            end



            def  columns

                attributes.map  {  |a|  column(a)  }.join("\n")

            end



            def  column(name)

                "#      column  :#{name.gsub(/_id$/,  '')}"

            end



            def  filters

                attributes.map  {  |a|  filter(a)  }.join("\n")

            end



            def  filter(name)

                "#  filter  :#{name.gsub(/_id$/,  '')}"

            end

        end

    end

end

