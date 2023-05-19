package com.example.queryrows;

import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.view.View;

import android.view.Menu;
import android.view.MenuItem;
import java.util.ArrayList;

import jp.co.techknowledge.dbLib;
import jp.co.techknowledge.dbLib.Column;
import jp.co.techknowledge.dbLib.Row;
import jp.co.techknowledge.dbLib.status;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class MainActivity extends AppCompatActivity implements Runnable {
    private Handler _handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        startThread();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    private void performQueryRows(){

        try {
            dbLib.status st;
            dbLib db = new dbLib();
            // db.setURL("http://192.168.0.5");		// <<==== 環境に合わせて変更してください。
            db.setURL("http://192.168.0.18:8000");

            st = db.connect();
            if(st == status.Normal){
                st = db.queryRows("select empno,ename,job from emp",100);
                if(st == status.Normal){
                    //
                    ArrayList <String> results = new ArrayList<String>();
                    ArrayList<dbLib.Row> rows = db.getRows();
                    //
                    for(int i=0; i<rows.size(); i++){
                        //
                        Row row = rows.get(i);
                        String line="";
                        ArrayList<Column> cols = row.columns;
                        for(int j=0; j<cols.size(); j++){
                            String name  = cols.get(j).name;
                            String value = cols.get(j).value;
                            line += name + "=" + value + " ";
                        }
                        results.add(line);
                    }

                    // set array adapter.
                    final ArrayAdapter<String> la = new ArrayAdapter<String>(this,  android.R.layout.simple_list_item_1,results);
                    _handler.post(new Runnable() {
                        public void run() {
                            // set array adapter.
                            ListView lv = (ListView) findViewById(R.id.resultList);
                            lv.setAdapter(la);
                        }
                    });
                }
            }
            db.disconnect();
        }
        catch(Exception ex){
            Log.v("test",ex.getMessage());
            ex.printStackTrace();
        }
    }

    private void startThread(){
        Thread thread = new Thread(this);
        thread.start();
    }

    @Override
    public void run() {
        performQueryRows();
    }
}