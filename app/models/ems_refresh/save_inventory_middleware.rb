module EmsRefresh::SaveInventoryMiddleware
  def save_ems_middleware_inventory(ems, hashes, target = nil)
    target = ems if target.nil?

    child_keys = [:middleware_servers, :middleware_deployments]

    # Save and link other subsections
    child_keys.each do |k|
      send("save_#{k}_inventory", ems, hashes[k], target)
    end

    ems.save!
  end

  def save_middleware_servers_inventory(ems, hashes, target = nil)
    return if hashes.nil?
    target = ems if target.nil?

    ems.middleware_servers(true)
    deletes = if target.kind_of?(ExtManagementSystem)
                :use_association
              else
                []
              end

    save_inventory_multi(ems.middleware_servers, hashes, deletes, [:ems_ref])
    store_ids_for_new_records(ems.middleware_servers, hashes, :ems_ref)
  end

  def save_middleware_deployments_inventory(ems, hashes, target = nil)
    return if hashes.nil?
    target = ems if target.nil?

    ems.middleware_deployments(true)
    deletes = if target.kind_of?(ExtManagementSystem)
                :use_association
              else
                []
              end

    hashes.each do |h|
      h[:server_id] = h.fetch_path(:middleware_server, :id)
    end

    save_inventory_multi(ems.middleware_deployments, hashes, deletes, [:ems_ref], nil,
                         [:middleware_server])
    store_ids_for_new_records(ems.middleware_deployments, hashes, :ems_ref)
  end
end
