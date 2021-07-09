module Spree
    module PermissionSets
        class Blogger < PermissionSets::Base
            def activate!
                can :manage, Spree::Blog
            end
        end
    end
end