package de.dsa_aachen.dsa_elements_summons;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import de.dsa_aachen.dsa_elements_summons.placeholder.PlaceholderContent;

/**
 * A fragment representing a list of Items.
 */
public class CharacterFragment extends Fragment {

    // TODO: Customize parameter argument names
    private static final String ARG_COLUMN_COUNT = "column-count";
    private Button addCharacter;
    private RecyclerView recyclerView;
    // TODO: Customize parameters
    private int mColumnCount = 1;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public CharacterFragment() {
    }

    // TODO: Customize parameter initialization
    @SuppressWarnings("unused")
    public static CharacterFragment newInstance(int columnCount) {
        CharacterFragment fragment = new CharacterFragment();
        Bundle args = new Bundle();
        args.putInt(ARG_COLUMN_COUNT, columnCount);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (getArguments() != null) {
            mColumnCount = getArguments().getInt(ARG_COLUMN_COUNT);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.character_item_list, container, false);

        // Set the adapter
        if (rootView.findViewById(R.id.list_characters) instanceof RecyclerView) {
            Context context = rootView.getContext();
            recyclerView = (RecyclerView) rootView.findViewById(R.id.list_characters);
            if (mColumnCount <= 1) {
                recyclerView.setLayoutManager(new LinearLayoutManager(context));
            } else {
                recyclerView.setLayoutManager(new GridLayoutManager(context, mColumnCount));
            }
            recyclerView.setAdapter(new MyCharacterRecyclerViewAdapter(PlaceholderContent.ITEMS));
        }


        addCharacter = (Button)rootView.findViewById(R.id.add_character);
        addCharacter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if( v instanceof Button) {
                    ((MyCharacterRecyclerViewAdapter) recyclerView.getAdapter()).addItem(new PlaceholderContent.PlaceholderItem(getString(R.string.title_add_character)));
                    ((MyCharacterRecyclerViewAdapter) recyclerView.getAdapter()).notifyDataSetChanged();
                }
            }
        });
        return rootView;
    }
}
