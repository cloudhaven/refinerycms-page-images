module Refinery
  module PageImages
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery

      engine_name :refinery_page_images

      def self.register(tab)
        tab.name = "images"
        tab.partial = "/refinery/admin/pages/tabs/images"
      end

      initializer "register refinery_page_images plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "page_images"
          plugin.hide_from_menu = true
        end
      end

      config.to_prepare do
        require 'refinerycms-pages'
        Refinery::PageImages.mountings.each do |mountable|
            mountable.constantize.send :has_many_page_images
        end
        Refinery::Image.module_eval do
          has_many :image_pages, :dependent => :destroy
        end
      end

      config.after_initialize do


        Refinery::PageImages.mountings.each do |mountable|
          registerable, mount_parts = "", mountable.split("::")
          case mount_parts.size
          when 3
            registerable = "#{mount_parts[0]}::#{mount_parts[1]}::Tab"
          when 2
            # massive hack here, need to have a better way of detecting what the right
            # class to inject the tab into is going to be e.g. Page -> Pages
            registerable = "#{mountable}s::Tab"
          end
          registerable.constantize.register do |tab|
            register tab
          end
        end

        Refinery.register_engine(Refinery::PageImages)
      end
    end
  end
end