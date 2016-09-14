module Sufia
  class AdminSetPresenter < CollectionPresenter
    def total_items(admin_set = self)
      ActiveFedora::SolrService.query("{!field f=isPartOf_ssim}#{admin_set.id}", fl: admin_set.id).length
    end
  end
end
