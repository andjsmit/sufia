module Sufia
  class Admin::AdminSetsController < ApplicationController
    include CurationConcerns::CollectionsControllerBehavior
    load_and_authorize_resource
    layout 'admin'
    self.presenter_class = Sufia::AdminSetPresenter
    self.form_class = Sufia::Forms::AdminSetForm

    # Used for the show action
    self.single_item_search_builder_class = Sufia::SingleAdminSetSearchBuilder

    # Used to get the members for the show action
    self.member_search_builder_class = Sufia::AdminSetMemberSearchBuilder

    # Used to get a list of admin sets for the index action
    class_attribute :list_search_builder_class
    self.list_search_builder_class = CurationConcerns::AdminSetSearchBuilder

    def show
      add_breadcrumb t(:'sufia.controls.home'), root_path
      add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
      add_breadcrumb t(:'sufia.admin.sidebar.admin_sets'), sufia.admin_admin_sets_path
      add_breadcrumb 'View Set', request.path
      super
    end

    def index
      authorize! :manage, AdminSet
      add_breadcrumb t(:'sufia.controls.home'), root_path
      add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
      add_breadcrumb t(:'sufia.admin.sidebar.admin_sets'), sufia.admin_admin_sets_path
      @admin_sets = CurationConcerns::AdminSetService.new(self).search_results(:read)
      @presenter = presenter_class.new(self, current_ability)
    end

    def new
      setup_form
    end

    def edit
      setup_form
    end

    def update
      if @admin_set.update_attributes(admin_set_params)
        redirect_to sufia.admin_admin_sets_path
      else
        setup_form
        render :edit
      end
    end

    def create
      if create_admin_set
        redirect_to sufia.admin_admin_sets_path
      else
        setup_form
        render :new
      end
    end

    # for the AdminSetService
    def repository
      repository_class.new(blacklight_config)
    end

    # Override the default prefixes so that we use the collection partals.
    def self.local_prefixes
      ["sufia/admin/admin_sets", "collections", 'catalog']
    end

    private

      # Overriding the way that the search builder is initialized
      def collections_search_builder
        list_search_builder_class.new(self, :read)
      end

      def create_admin_set
        AdminSetService.new(@admin_set, current_user).create
      end

      def setup_form
        add_breadcrumb t(:'sufia.controls.home'), root_path
        add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
        add_breadcrumb t(:'sufia.admin.sidebar.admin_sets'), sufia.admin_admin_sets_path
        add_breadcrumb action_breadcrumb, request.path
        @form = form_class.new(@admin_set)
      end

      def action_breadcrumb
        case action_name
        when 'edit', 'update'
          t(:'helpers.action.edit')
        else
          t(:'helpers.action.admin_set.new')
        end
      end

      def admin_set_params
        form_class.model_attributes(params[:admin_set])
      end

      def repository_class
        blacklight_config.repository_class
      end
  end
end
