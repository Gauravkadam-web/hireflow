package com.hireflow.dao;

import com.hireflow.model.Category;
import com.hireflow.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAll() throws SQLException {
        String sql = "SELECT category_id, name, icon, job_count " +
                "FROM categories ORDER BY name";

        List<Category> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setIcon(rs.getString("icon"));
                c.setJobCount(rs.getInt("job_count"));
                list.add(c);
            }
        }
        return list;
    }
}
